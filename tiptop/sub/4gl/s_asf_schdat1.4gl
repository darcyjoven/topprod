# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: s_asf_schdat1.4gl
# Descriptions...: Schedule W/O AND Tracking Date
# Date & Author..: 90/12/13 By Lee
# Usage..........: CALL s_asf_schdat1(p_opt,p_strtdat,p_duedat,p_bomdat,p_wono,
#                                     p_primary,p_wotype,p_part,p_woq,p_usedate)
#                  RETURNING l_irr,l_strtdat,l_duedat,l_type,l_track
# Input Parameter: p_opt       Options
#                     0    normal use
#                     1    do not generate tracking file
#                  p_strtdat   Start Date of W/O
#                  p_duedat    Due Date of W/O
#                  p_bomdat    BOM Effective Date
#                  p_wono      W/O Number
#                  p_primary   Routing Primary Code
#                  p_wotype    W/O type
#                  p_part      part number
#                  p_woq       W/O Qty
#                  p_usedate   若日期小於今日處理方式
# Return code....: l_irr       Results
#                  l_strtdat   Start Date
#                  l_duedat    Due Date
#                  l_type      Schele Method
#                  l_track     tracking file generated?(Y/N)
# Modify.........: 92/09/15 By PIN 在tracking file 加一欄位(盤點否)
# Modify.........: 01/05/31 BY ANN CHEN No.B524 第一站投入量改在工單確認才掛上
# Modify.........: No.MOD-4A0041 04/10/05 By Mandy Oracle DEFINE  INTEGER  應該轉為LIKE type_file.chr20  	#No.FUN-680147
# Modify.........: No.MOD-4A0041 在convert 作業中 才會做正確的轉換
# Modify.........: NO.FUN-670091 06/08/01 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.MOD-6C0099 06/12/25 By Sarah 客戶:光頡,執行asfp302無法正確產生工單
# Modify.........: No.FUN-760066 07/06/25 By kim 配合MSV版的調整
# Modify.........: No.FUN-710073 07/12/03 By jamie 1.UI將 '天' -> '天/生產批量'
#                                                  2.將程式有用到 'XX前置時間'改為乘以('XX前置時間' 除以 '生產單位批量(ima56)')
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.CHI-810015 08/01/17 By jamie 將FUN-710073修改部份還原
# Modify.........: No.FUN-980012 09/08/24 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-A70125 10/07/27 By lilingyu 平行工藝
# Modify.........: No.FUN-A70131 10/07/29 By destiny 平行工藝
# Modify.........: No:FUN-A80102 10/08/18 By kim GP5.25號機管理
# Modify.........: No.TQC-B80022 11/08/02 By jason INSERT INTO ecm_file給ecm66預設值'Y'
# Modify.........: No.CHI-B80096 11/09/02 By fengrui 對組成用量(ecm62)/底數(63)的預設值處理,計算標準產出量(ecm65)的值

DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE
    g_sfb RECORD LIKE sfb_file.*, #Work Order
    g_op ARRAY[1000] OF 
        RECORD
              qtytbc LIKE ecm_file.ecm291, #Qty to be complete
              offset1 LIKE ecm_file.ecm13, #offset(=FLT+ULT)
              offset2 LIKE ecm_file.ecm13, #offset(=ULT)
              ecm01   LIKE ecm_file.ecm01, #FUN-760066
              ecm03   LIKE ecm_file.ecm03  #FUN-760066
        END RECORD,
    g_type      LIKE type_file.chr1,       #No.FUN-680147 VARCHAR(1)
    g_track     LIKE type_file.chr1,   	   #No.FUN-680147 VARCHAR(1)
    g_lots      LIKE ima_file.ima56,       #production lot size
    g_wono      LIKE sfb_file.sfb01,       #work order nubmer
    g_wotype    LIKE sfb_file.sfb02,       #work order type
    g_part      LIKE sfb_file.sfb05,       #work order part number
    g_primary   LIKE sfb_file.sfb06,       #work order primary code
    g_usedate   LIKE type_file.chr1,   	   #No.FUN-680147 VARCHAR(1)
    g_opt       LIKE type_file.num5,   	   #No.FUN-680147 SMALLINT
    g_woq       LIKE sfb_file.sfb08 #Qty of W/O
 
DEFINE   g_cnt           LIKE type_file.num10     	#No.FUN-680147 INTEGER
FUNCTION s_asf_schdat1(p_opt    ,p_strtdat,p_duedat ,p_bomdat,p_wono,
                  p_primary,p_wotype ,p_part   ,p_woq   ,p_usedate)
DEFINE
    p_opt      LIKE type_file.num5,                  #No.FUN-680147 SMALLINT
    p_strtdat  LIKE type_file.dat,                   #Start Date    #No.FUN-680147 DATE
    p_duedat   LIKE type_file.dat,                   #Due Date 	    #No.FUN-680147 DATE
    p_bomdat   LIKE type_file.dat,                   #BOM Effective Date 	#No.FUN-680147 DATE
    p_wono     LIKE sfb_file.sfb01, #W/O
    p_part     LIKE sfb_file.sfb05, #work order part number
    p_wotype   LIKE sfb_file.sfb02, #work order type
    p_woq      LIKE sfb_file.sfb08, #Qty of W/O
    p_primary  LIKE ecb_file.ecb02, #Primary Code
    p_usedate  LIKE type_file.chr1,             #No.FUN-680147 VARCHAR(1)
    l_part     LIKE ima_file.ima01,
    l_exit     LIKE type_file.num5,   	        #No.FUN-680147 SMALLINT
    l_irr      LIKE type_file.num5   #Result 	#No.FUN-680147 SMALLINT
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    MESSAGE ' Scheduling ' ATTRIBUTE(REVERSE)
    #Check if all anytings available
    LET g_errno=' '
    LET g_track='N'
    SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01=p_wono 
 
    IF g_sfb.sfb93='N' AND g_sma.sma28='2' THEN
	LET g_errno='mfg5106'
        RETURN -1,p_strtdat,p_duedat,g_type,g_track
    END IF
 
    #scehduling method not defined
    IF g_sma.sma28 IS NULL        
        OR g_sma.sma28 NOT MATCHES '[12]' THEN  #out of range
	LET g_errno='mfg5100'
        RETURN -1,p_strtdat,p_duedat,g_type,g_track
        #system parameter #28 scheduling method not defined yet
    END IF
 
    #tracking method not defined
    IF g_sma.sma26 IS NULL       
        OR g_sma.sma26 NOT MATCHES '[123]' THEN #out of range
	LET g_errno='mfg5101'
        RETURN -2,p_strtdat,p_duedat,g_type,g_track
        #system parameter #26 tracking method not defined
    END IF
 
    #若使用料件的時距排程, 並使用者輸入預計開工及完工日,
    #則不為任何的推算
{
    IF g_sma.sma28='1' AND p_strtdat IS NOT NULL AND p_duedat IS NOT NULL THEN
        MESSAGE " "
        RETURN 1,p_strtdat,p_duedat,'0','N'
        #????? when up condition how to generate tracking file  #94/03/17 pin
    END IF
}
 
    #no problems, let's go
    #select detail data of w/o
    LET g_wono=p_wono
    LET g_wotype=p_wotype
    LET g_part=p_part
    LET g_primary=p_primary
    LET g_woq=p_woq
    LET g_usedate=p_usedate
    LET g_opt=p_opt
    LET g_errno= ' '
 
 
    IF (g_sfb.sfb93='Y' AND g_sma.sma28='2')	        #使用製程排程
            OR (g_sma.sma26 MATCHES '[23]') THEN	#產生製程追蹤
        LET g_cnt=0
        SELECT COUNT(*) INTO g_cnt FROM ecm_file
            WHERE ecm01=g_wono
           #  AND ecm02=g_wotype 
        IF SQLCA.sqlcode OR g_cnt=0 OR g_cnt IS NULL THEN #record not exist
             LET l_part=p_part
             LET l_exit=FALSE
             WHILE TRUE
                 #add new record to tracing file
                 CALL s_asf_put1(p_bomdat,l_part) RETURNING g_cnt 
                 #no record find, routing select error
{
                 IF NOT g_cnt THEN 
                   IF NOT l_exit THEN
	              LET l_exit=TRUE
	              #主製程料件
	              SELECT ima571 INTO l_part FROM ima_file WHERE ima01=p_part
	              IF SQLCA.SQLCODE OR l_part IS NULL OR l_part=' ' THEN
	                 LET g_errno='mfg5102'
	                 RETURN -4,p_strtdat,p_duedat,g_type,g_track
	              END IF
	           ELSE
	              LET g_errno='mfg5102'
                      RETURN -4,p_strtdat,p_duedat,g_type,g_track
                   END IF
                 ELSE
	           EXIT WHILE		#成功
	         END IF
}
	           EXIT WHILE		#成功#
	     END WHILE
        ELSE	#追蹤資料已存在!! 嚴重錯誤, 不可再繼續
	   LET g_errno='asf-016'
	   #system shutdown
	#  UPDATE sma_file SET sma01='N' WHERE sma00='0'
	   RETURN -99,p_strtdat,p_duedat,g_type,g_track
        END IF
    END IF
 
    #compute w/o qty
#   LET g_woq=g_sfb.sfb08-g_sfb.sfb09 
 
    #若使用製程, 雖不產生製程追蹤資料, 則仍以製程來推算其開/完工日
    IF g_sfb.sfb93='Y' AND g_sma.sma26='1' THEN LET g_opt=1 END IF
 
    #window scheduling(若不產生追蹤)
    IF g_sma.sma28 = '1' OR g_sfb.sfb93='N' THEN 
        CALL s_asf_winsch1(p_strtdat,p_duedat)
        RETURNING g_cnt,p_strtdat,p_duedat
    END IF
 
    #tracking scheduling & weighted window #製程排程
    IF (g_sma.sma28='2'  AND g_sfb.sfb93='Y') OR 
       (g_sma.sma26!='1' AND g_sma.sma28='1') THEN
       CALL s_asf_trksch1(p_strtdat,p_duedat)
       RETURNING g_cnt,p_strtdat,p_duedat
    END IF
 
    #check result for validation
    IF p_strtdat=g_lastdat THEN LET p_duedat=g_lastdat   END IF
    IF p_duedat=g_lastdat  THEN LET p_strtdat='01/01/01' END IF
    MESSAGE ""
    RETURN g_cnt,p_strtdat,p_duedat,g_type,g_track
END FUNCTION
 
#Window Scheduling
FUNCTION s_asf_winsch1(p_strtdat,p_duedat)
DEFINE
    p_strtdat LIKE type_file.dat,                   #start date 	#No.FUN-680147 DATE
    p_duedat  LIKE type_file.dat,                   #due date    	#No.FUN-680147 DATE
    l_date    LIKE type_file.dat,    	            #No.FUN-680147 DATE
    l_alot    LIKE ima_file.ima59  #part's lead time
 
    #both start and due date defined
    IF p_strtdat IS NOT NULL AND p_duedat IS NOT NULL THEN
	LET g_errno='mfg5103'
        RETURN -9,p_strtdat,p_duedat
    END IF
    #select part's lead time
    CALL s_asf_lt1() RETURNING l_alot
    #selection error
    IF l_alot IS NULL THEN 
        LET g_errno='mfg5104' 
        RETURN -10,p_strtdat,p_duedat
    END IF
 
    IF p_strtdat IS NULL THEN 
        #backward
        LET l_alot=l_alot*-1
        LET l_date=p_duedat
        LET g_type='2'
    ELSE  
        #forward
        LET l_date=p_strtdat
        LET g_type='1'
    END IF
 
    CALL s_getdate(l_date,l_alot) RETURNING l_date
    IF p_strtdat IS NULL THEN 
       LET p_strtdat=l_date 
    ELSE 
       LET p_duedat=l_date
    END IF
 
    #adjust if start date before today
    IF p_strtdat < g_today THEN 
        IF g_usedate='1' THEN LET p_strtdat=g_today END IF
    END IF
    RETURN 1,p_strtdat,p_duedat
END FUNCTION
 
#tracking Scheduling & weighted window
FUNCTION s_asf_trksch1(p_strtdat,p_duedat)
DEFINE
    p_strtdat LIKE type_file.dat,                 #start date 	#No.FUN-680147 DATE
    p_duedat LIKE type_file.dat,                  #due date 	#No.FUN-680147 DATE
   #bb-----
    w_bdate,w_edate LIKE type_file.dat,          #No.FUN-680147 DATE
    w_day   LIKE type_file.num5,        	 #No.FUN-680147 SMALLINT
    w_flag  LIKE type_file.chr1,   		 #No.FUN-680147 VARCHAR(1)
    l_ecm RECORD LIKE ecm_file.*,
   #bb-----
    l_need1 LIKE ecm_file.ecm07,        #total offset1
    l_need2 LIKE ecm_file.ecm07,        #total offset1
    l_b1 LIKE ecm_file.ecm07,
    l_b2 LIKE ecm_file.ecm07,
    l_e1 LIKE ecm_file.ecm07,
    l_e2 LIKE ecm_file.ecm07,
    l_i LIKE type_file.num5,   #index 	#No.FUN-680147 SMALLINT
    l_date LIKE type_file.dat,    	#No.FUN-680147 DATE
    l_flt LIKE ima_file.ima59,          #routing's fixed lead time(FLT)
    l_ult LIKE ima_file.ima60,          #routing's unit lead time(ULT)
    l_weighted LIKE type_file.num5,     #weighted flag 	#No.FUN-680147 SMALLINT
    l_cnt LIKE type_file.num5,          #total number counted 	#No.FUN-680147 SMALLINT
    l_alot LIKE ima_file.ima59,  #part's lead time
    l_alot2 LIKE ima_file.ima59  #part's lead time
 
    LET l_weighted=0
    IF p_strtdat IS NOT NULL #both start and due date defined
        AND p_duedat IS NOT NULL THEN
        LET l_weighted=1
    END IF
 
    #selection error
    CALL s_asf_lt1() RETURNING l_alot
    IF l_alot IS NULL THEN                  
	LET g_errno='mfg5014'
        RETURN -10,p_strtdat,p_duedat
    END IF
    LET l_alot2=l_alot
 
   #CALL s_asf_total1() RETURNING l_cnt,l_need1,l_need2   #MOD-6C0099 mark
    CALL s_asf_total1() RETURNING g_cnt,l_need1,l_need2   #MOD-6C0099
    IF g_cnt=1    THEN LET g_errno='mfg5015' RETURN -4,'','' END IF
    IF g_cnt>1000 THEN LET g_errno='mfg5015' RETURN -5,'','' END IF
 
    IF NOT l_weighted THEN
        IF p_strtdat IS NULL THEN #backward
            LET l_need1=l_need1*-1
            LET l_date=p_duedat
            LET g_type='5'
        ELSE  #forward
            LET l_date=p_strtdat
            LET g_type='4'
        END IF
        CALL s_getdate(l_date,l_need1) RETURNING l_date
        IF p_strtdat IS NULL THEN
            LET p_strtdat=l_date
        ELSE
            LET p_duedat=l_date
        END IF
    ELSE
        LET g_type='3'
    END IF
 
    #adjust if start date before today
    IF p_strtdat < g_today THEN 
        IF g_usedate='1' THEN
            LET p_strtdat=g_today
            LET l_weighted=1
            LET l_need1=l_need1-(g_today-p_strtdat)
            LET l_need2=l_need2-(g_today-p_strtdat)
        END IF
    END IF
 
   #LET l_cnt=l_cnt-1   #MOD-6C0099 mark
    LET g_cnt=g_cnt-1   #MOD-6C0099
    IF g_opt=1 THEN
        DELETE FROM ecm_file WHERE ecm01=g_wono AND ecm11=g_primary
        IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN 
           #CALL cl_err('del_ecm',STATUS,0) #FUN-670091
           CALL cl_err3("del","ecm_file",g_wono,g_primary,STATUS,"",'del_ecm',0) #FUN-670091
           LET g_success = 'N'
        END IF 
        LET g_track='N'
        RETURN l_cnt,p_strtdat,p_duedat
    END IF
 
    IF NOT l_weighted THEN
        LET l_alot=l_need1
        LET l_alot2=l_need2
    ELSE #how many days in the specified time frame
        CALL s_ofday(p_strtdat,p_duedat) RETURNING l_alot
        IF l_need1 = 0 THEN LET l_need1 = 0.01 END IF
        LET l_alot2=l_alot*(l_need2/l_need1)
    END IF
    LET l_b1=0
    LET l_b2=0
    IF l_need1=0 THEN LET l_need1=1 END IF
    IF l_need2=0 THEN LET l_need2=1 END IF
   #FOR l_i=1 TO l_cnt   #MOD-6C0099 mark
    FOR l_i=1 TO g_cnt   #MOD-6C0099
        LET l_e1=l_b1+(g_op[l_i].offset1*(l_alot/l_need1))
        LET l_e2=l_b2+(g_op[l_i].offset2*(l_alot2/l_need2))
        UPDATE ecm_file
           SET ecm07=l_e1,ecm08=l_e2,
               ecm09=l_b2,ecm10=l_b1
          WHERE ecm01=g_op[l_i].ecm01 AND ecm03=g_op[l_i].ecm03 #MOD-4A0041
        IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN 
           CALL cl_err('upd_ecm1',STATUS,0)
           LET g_success = 'N'
        END IF 
        LET l_b1=l_e1
        LET l_b2=l_e2
    END FOR
 #bb-----
   IF g_type='4' THEN
    DECLARE c_trk1 CURSOR FOR
      SELECT * 
        FROM ecm_file 
       WHERE ecm01=g_wono 
        ORDER BY ecm03
      LET w_bdate=p_strtdat
    FOREACH c_trk1 INTO l_ecm.*
      LET w_day=(l_ecm.ecm14+l_ecm.ecm13)/86400 +0.99    # 一天86400秒
      CALL s_wknxt(w_bdate,w_day) RETURNING w_flag,w_edate
      CALL s_wknxt(w_edate,-1) RETURNING w_flag,p_duedat 
      UPDATE ecm_file set ecm50=w_bdate,ecm51=p_duedat WHERE ecm01=l_ecm.ecm01
                                                          AND ecm03=l_ecm.ecm03
      LET w_bdate=w_edate  
    END FOREACH
  ELSE    #Is  ELSE or must be g_type = '5' backward (sfb32 起始scheduling method)
    DECLARE c_trk2 CURSOR FOR
      SELECT * 
        FROM ecm_file 
       WHERE ecm01=g_wono 
        ORDER BY ecm03 DESC
      LET w_edate=p_duedat
    FOREACH c_trk2 INTO l_ecm.*
      LET w_day=((l_ecm.ecm14+l_ecm.ecm13)/86400 +0.99)*-1    # 一天86400秒
      CALL s_wknxt(w_edate,w_day) RETURNING w_flag,w_bdate
      CALL s_wknxt(w_bdate,1) RETURNING w_flag,p_strtdat
      UPDATE ecm_file set ecm51=w_edate,ecm50=p_strtdat WHERE ecm01=l_ecm.ecm01
                                                          AND ecm03=l_ecm.ecm03
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN 
         #CALL cl_err('upd_ecm2',STATUS,0) #FUN-670091
         CALL cl_err3("upd","ecm_file",l_ecm.ecm01,l_ecm.ecm03,STATUS,"",'del_ecm',0) #FUN-670091
         LET g_success = 'N'
      END IF 
      LET w_edate=w_bdate 
    END FOREACH
  END IF
 #bb-----
   #RETURN l_cnt,p_strtdat,p_duedat   #MOD-6C0099 mark
    RETURN g_cnt,p_strtdat,p_duedat   #MOD-6C0099
END FUNCTION
 
#accumulated total need time
FUNCTION s_asf_total1()
DEFINE
    l_ecm RECORD LIKE ecm_file.*,    #tracking detail file
    l_need1 LIKE ecm_file.ecm07,     #total offset1
    l_need2 LIKE ecm_file.ecm07,     #total offset1
    l_wc LIKE ecb_file.ecb08,        #work center
    l_eca04 LIKE eca_file.eca04,     #work center type code
    l_eca06 LIKE eca_file.eca06,     #intensity flag
    l_eca08 LIKE eca_file.eca08,     #capacity hour per day
    l_eca09 LIKE eca_file.eca09,     #work center queue time
    l_flt LIKE ima_file.ima59,       #routing's fixed lead time(FLT)
    l_ult LIKE ima_file.ima60,       #routing's unit lead time(ULT)
    l_run LIKE ecm_file.ecm39,       #runtime
    l_qty LIKE ecm_file.ecm291,
    l_lots LIKE type_file.num5,   #production lot size 	#No.FUN-680147 SMALLINT
    l_double LIKE ecm_file.ecm40
 
    DECLARE c_trk CURSOR FOR
     #SELECT *                     #MOD-6C0099 mark
      SELECT ecm_file.*   #MOD-6C0099
        FROM ecm_file 
       WHERE ecm01=g_wono 
#bb--------
    #    AND ecm11=g_primary  
    # ORDER BY ecm03 DESC
#bb--------
    LET g_cnt=1
    LET l_wc='!@#$%^&*()'
    #accumulate total need time
    LET l_need1=0
    LET l_need2=0
     FOREACH c_trk INTO l_ecm.* #MOD-4A0041
        IF SQLCA.sqlcode THEN EXIT FOREACH END IF
        #FUN-760066.............begin
        LET g_op[g_cnt].ecm01=l_ecm.ecm01
        LET g_op[g_cnt].ecm03=l_ecm.ecm03
        #FUN-760066.............end
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
        ELSE
            LET l_eca09=0
        END IF
        #compute qty to be complete
        LET l_qty=l_ecm.ecm311+l_ecm.ecm312+l_ecm.ecm313+l_ecm.ecm314
        IF l_qty=0 THEN #nothing produced
            LET g_op[g_cnt].qtytbc=g_woq
        ELSE
            #QtyTbC=woq-trcaqty-trctqty-trscr-trrewqty-scraped&rework
            LET g_op[g_cnt].qtytbc=g_woq+
                l_ecm.ecm302-l_qty
        END IF
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
 
        IF l_ecm.ecm43='1' THEN #hr/unit
            LET l_ult=((l_run*g_op[g_cnt].qtytbc)/(l_eca08*60*l_double))
        ELSE #unit/hr
            LET l_ult=((g_op[g_cnt].qtytbc)/(l_eca08*60*l_run*l_double))
        END IF
 
        IF l_flt IS NULL THEN LET l_flt=0 END IF
        IF l_ult IS NULL THEN LET l_ult=0 END IF
       #FUN_710073---mod---str---
       #LET g_op[g_cnt].offset1=l_flt+l_ult                                   
       #LET g_op[g_cnt].offset2=l_ult                                         
       #LET l_need1=l_need1+l_flt+l_ult                                       
       #LET l_need2=l_need2+l_ult                                             
        LET g_op[g_cnt].offset1=(l_flt/g_lots)+(l_ult/g_lots)                
        LET g_op[g_cnt].offset2=(l_ult/g_lots)                               
        LET l_need1=l_need1+(l_flt/g_lots)+(l_ult/g_lots)                    
        LET l_need2=l_need2+(l_ult/g_lots)                                   
       #FUN_710073---mod---end---
        LET g_cnt=g_cnt+1
        IF g_cnt>1000 THEN EXIT FOREACH END IF
    END FOREACH
    RETURN g_cnt,l_need1,l_need2
END FUNCTION
 
#select part's lead time
FUNCTION s_asf_lt1()
DEFINE
    l_alot LIKE ima_file.ima59, #part's lead time
    l_flt LIKE ima_file.ima59,  #part's fixed lead time(FLT)
    l_ult LIKE ima_file.ima60   #part's unit lead time(ULT)
 
    #select part's lead time
    SELECT ima56,ima59,ima60
        INTO g_lots,l_flt,l_ult
        FROM ima_file
        WHERE ima01=g_part AND imaacti='Y'
    IF SQLCA.sqlcode THEN  LET g_lots=1 RETURN '' END IF
    IF g_lots IS NULL OR g_lots=0 THEN LET g_lots=1 END IF
    #compute lead
    IF l_flt IS NULL THEN LET l_flt=0 END IF
    IF l_ult IS NULL THEN LET l_ult=0 END IF
    LET l_alot=l_flt+(l_ult*g_woq)                   #CHI-810015 mark還原 #FUN-710073 mark
   #LET l_alot=(l_flt/g_lots)+(l_ult/g_lots*g_woq)   #CHI-810015 mark #FUN-710073 mod
    RETURN l_alot
END FUNCTION
#bb---------
#Add new record of tracking file
FUNCTION s_asf_put1(p_bomdat,p_part)
DEFINE
    p_bomdat LIKE type_file.dat,    	#No.FUN-680147 DATE
    p_part   LIKE ima_file.ima01,
    l_ima55  LIKE ima_file.ima55,
    l_sfb08  LIKE sfb_file.sfb08,    #CHI-B80096--add--
    l_ecm012 LIKE ecm_file.ecm012,   #CHI-B80096--add--
    l_ecb    RECORD LIKE ecb_file.*, #routing detail file
    l_ecm    RECORD LIKE ecm_file.*, #routing detail file
    l_sgc    RECORD LIKE sgc_file.*, #routing detail file
    l_sgd    RECORD LIKE sgd_file.*  #routing detail file
 
    DECLARE c_put CURSOR FOR
        SELECT * FROM ecb_file
            WHERE ecb01=p_part #part
                AND ecb02=g_primary #routing
                AND ecbacti='Y'
            ORDER BY ecb03 #製程序號
    LET g_cnt=0
    FOREACH c_put INTO l_ecb.*
        IF SQLCA.sqlcode THEN EXIT FOREACH END IF
        INITIALIZE l_ecm.* TO NULL  
        LET l_ecm.ecm01      =  g_wono
        LET l_ecm.ecm02      =  g_wotype
        SELECT sfb05 INTO g_part FROM sfb_file WHERE sfb01=g_wono
        LET l_ecm.ecm03_par  =  g_part
        LET l_ecm.ecm03      =  l_ecb.ecb03
        LET l_ecm.ecm04      =  l_ecb.ecb06
        LET l_ecm.ecm05      =  l_ecb.ecb07
        LET l_ecm.ecm06      =  l_ecb.ecb08
        LET l_ecm.ecm07      =  0           
        LET l_ecm.ecm08      =  0           
        LET l_ecm.ecm09      =  0           
        LET l_ecm.ecm10      =  0           
        LET l_ecm.ecm11      =  l_ecb.ecb02          #製程編號
        LET l_ecm.ecm13      =  l_ecb.ecb18          #固定工時(秒)
        LET l_ecm.ecm14      =  l_ecb.ecb19*g_woq    #標準工時(秒)
        LET l_ecm.ecm15      =  l_ecb.ecb20          #固定機時(秒)
        LET l_ecm.ecm16      =  l_ecb.ecb21*g_woq    #標準機時(秒)
        LET l_ecm.ecm49      =  l_ecb.ecb38*g_woq    #製程人力
        LET l_ecm.ecm45      =  l_ecb.ecb17          #作業名稱
        LET l_ecm.ecm52      =  l_ecb.ecb39          #SUB 否
        LET l_ecm.ecm53      =  l_ecb.ecb40          #PQC 否
        LET l_ecm.ecm54      =  l_ecb.ecb41          #Check in 否
        LET l_ecm.ecm55      =  l_ecb.ecb42          #Check in Hold 否
        LET l_ecm.ecm56      =  l_ecb.ecb43          #Check Out Hold 否
        #------>
        LET l_ecm.ecm291     =  0           
        LET l_ecm.ecm292     =  0           
        #=========================================================
        #No.B524 010531 BY ANN CHEN
        #第一站投入量[ecm301]改在工單確認時才掛上
        #IF g_cnt=0    #第一站default投入量=生產套數
        #   THEN
        #   LET l_ecm.ecm301     =  g_woq
        #ELSE
           LET l_ecm.ecm301     =  0           
        #END IF
        #No.B524 END =============================================
        LET l_ecm.ecm302     =  0           
        LET l_ecm.ecm303     =  0           
        LET l_ecm.ecm311     =  0           
        LET l_ecm.ecm312     =  0           
        LET l_ecm.ecm313     =  0           
        LET l_ecm.ecm314     =  0           
        LET l_ecm.ecm315     =  0           #bonus
        LET l_ecm.ecm316     =  0           #bonus
        LET l_ecm.ecm321     =  0           
        LET l_ecm.ecm322     =  0           
        #------>
        LET l_ecm.ecm57      = l_ecb.ecb44
        LET l_ecm.ecm58      = l_ecb.ecb45
        LET l_ecm.ecm59      = l_ecb.ecb46
        LET l_ecm.ecm62      = l_ecb.ecb46    #CHI-B80096--add--
        LET l_ecm.ecm63      = l_ecb.ecb51    #CHI-B80096--add--
        LET l_ecm.ecm65      =  0             #CHI-B80096--add--
        LET l_ecm.ecmacti    =  'Y'           
        LET l_ecm.ecmuser    =  g_user         
        LET l_ecm.ecmgrup    =  g_grup        
        LET l_ecm.ecmmodu    =  ''           
        LET l_ecm.ecmdate    =  g_today      
        LET l_ecm.ecmplant   = g_plant  #FUN-980012 add
        LET l_ecm.ecmlegal   = g_legal  #FUN-980012 add
#FUN-A70125 --begin--
        IF cl_null(l_ecm.ecm012) THEN
            LET l_ecm.ecm012 = ' '
        END IF 
#FUN-A70125 --end--
        LET l_ecm.ecm66 = l_ecb.ecb66  #FUN-A80102
        IF cl_null(l_ecm.ecm66) THEN LET l_ecm.ecm66 = 'Y' END IF #TQC-B80022
        IF cl_null(l_ecm.ecm62) OR l_ecm.ecm62 = 0 THEN LET l_ecm.ecm62 = 1 END IF #CHI-B80096--add--
        IF cl_null(l_ecm.ecm63) OR l_ecm.ecm63 = 0 THEN LET l_ecm.ecm63 = 1 END IF #CHI-B80096--add--
        INSERT INTO ecm_file VALUES(l_ecm.*)
        IF STATUS THEN       
           #CALL cl_err('ins_ecm',STATUS,1) #FUN-670091
           CALL cl_err3("ins","ecm_file","","",STATUS,"",'del_ecm',0) #FUN-670091
           LET g_success = 'N'
           EXIT FOREACH 
        END IF 
 
        #------>insert sgd_file
        #------>工單製程單元資料 
        DECLARE sgc_cur CURSOR FOR 
           SELECT * FROM sgc_file 
            WHERE  sgc01 = l_ecb.ecb01
              AND  sgc02 = l_ecb.ecb02
              AND  sgc03 = l_ecb.ecb03
              AND  sgc04 = l_ecb.ecb08
        FOREACH sgc_cur INTO l_sgc.*
           IF SQLCA.sqlcode THEN EXIT FOREACH END IF
           INITIALIZE l_sgd.* TO NULL  
           LET l_sgd.sgd00 = g_wono
           LET l_sgd.sgd01 = l_sgc.sgc01
           LET l_sgd.sgd02 = l_sgc.sgc02
           LET l_sgd.sgd03 = l_sgc.sgc03
           LET l_sgd.sgd04 = l_sgc.sgc04
           LET l_sgd.sgd05 = l_sgc.sgc05
           LET l_sgd.sgd06 = l_sgc.sgc06
           LET l_sgd.sgd07 = l_sgc.sgc07
           LET l_sgd.sgd08 = l_sgc.sgc08
           LET l_sgd.sgd09 = l_sgc.sgc09
           LET l_sgd.sgdplant = g_plant #FUN-980012 add
           LET l_sgd.sgdlegal = g_legal #FUN-980012 add
           #No.FUN-A70131--begin
           IF cl_null(l_sgd.sgd012) THEN 
              LET l_sgd.sgd012=' '
           END IF 
           IF cl_null(l_sgd.sgd03) THEN 
              LET l_sgd.sgd03=0
           END IF 
           #No.FUN-A70131--end             
           INSERT INTO sgd_file VALUES(l_sgd.*)
         # IF STATUS THEN 
         #    CALL cl_err('ins_sgd',STATUS,1)
         #    LET g_success= 'N'
         # END IF 
        END FOREACH
        LET g_cnt=g_cnt+1
    END FOREACH
    #---------------------------------------->
    #CHI-B80096--add--Begin--
    IF g_success = 'Y' THEN
       LET l_ecm012= ' '
       LET l_sfb08 = ' '
       SELECT DISTINCT sfb08 INTO l_sfb08
         FROM sfb_file WHERE sfb01 = g_wono
       DECLARE schdat1_ecm012_cs CURSOR FOR
          SELECT DISTINCT ecm012 FROM ecm_file
           WHERE ecm01= g_wono
             AND (ecm015 IS NULL OR ecm015=' ')
       FOREACH schdat1_ecm012_cs INTO l_ecm012
          EXIT FOREACH
       END FOREACH

       CALL s_schdat_output(l_ecm012,l_sfb08,g_wono)
    END IF
    #CHI-B80096--add---End---
 
    IF g_cnt > 0 THEN LET g_track='Y' END IF
    RETURN g_cnt
END FUNCTION
